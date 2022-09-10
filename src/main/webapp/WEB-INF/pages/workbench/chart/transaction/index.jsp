<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <%
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
                request.getServerPort() + request.getContextPath() + "/";
    %>
    <base href="<%=basePath%>"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function(){

            $.ajax({
                url : 'workbench/chart/transaction/queryCountOfTranGroupByStage.do',
                dataType : 'json',
                type : 'get',
                success : function (data){

                    let myChart = echarts.init(document.getElementById('main'));

                    let option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '交易信息中各个阶段的数量'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b} : {c}'
                        },
                        toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                        },
                        series: [
                            {
                                name: '数据量',
                                type: 'funnel',
                                left: '10%',
                                width: '80%',
                                label: {
                                    position: 'inside',
                                    formatter: '{b}',
                                    color: '#fff'
                                },
                                labelLine: {
                                    show: true
                                },
                                itemStyle: {
                                    opacity: 0.7,
                                    borderColor: '#fff',
                                    borderWidth: 2
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter: '{b}: {c}'
                                    }
                                },
                                data: data
                            }
                        ]
                    };

                    myChart.setOption(option);
                }
            });



        });
    </script>
    <title>Title</title>
</head>
<body>
    <div id="main" style="width: 600px;height: 300px;"></div>
</body>
</html>
